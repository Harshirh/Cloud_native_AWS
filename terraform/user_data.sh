#!/bin/bash
set -Eeuo pipefail

exec > >(tee -a /var/log/ecommerce-bootstrap.log | logger -t ecommerce-bootstrap -s 2>/dev/console) 2>&1

APP_IMAGE="${app_image}"
AWS_REGION="${aws_region}"

dnf install -y docker

if ! rpm -q amazon-ssm-agent >/dev/null 2>&1; then
  dnf install -y "https://s3.$${AWS_REGION}.amazonaws.com/amazon-ssm-$${AWS_REGION}/latest/linux_amd64/amazon-ssm-agent.rpm"
fi

systemctl enable --now amazon-ssm-agent
systemctl is-active --quiet amazon-ssm-agent

systemctl enable --now docker
docker pull "$${APP_IMAGE}"

install -d -o root -g root -m 700 /opt/ecommerce

cat > /usr/local/sbin/start-ecommerce <<'START_SCRIPT'
#!/bin/bash
set -Eeuo pipefail

APP_IMAGE="${app_image}"
ENV_FILE="/opt/ecommerce/.env"

if [[ ! -f "$${ENV_FILE}" ]]; then
  echo "Create /opt/ecommerce/.env before starting the application." >&2
  exit 1
fi

for required_name in SUPABASE_URL SUPABASE_SERVICE_ROLE_KEY; do
  if ! grep -qE "^$${required_name}=.+$" "$${ENV_FILE}"; then
    echo "A required environment variable is missing from /opt/ecommerce/.env." >&2
    exit 1
  fi
done

if ! grep -q '^PORT=3000$' "$${ENV_FILE}"; then
  echo "PORT must be set to 3000 in /opt/ecommerce/.env." >&2
  exit 1
fi

chmod 600 "$${ENV_FILE}"

docker run --detach \
  --name ecommerce-app \
  --publish 80:3000 \
  --restart unless-stopped \
  --env-file "$${ENV_FILE}" \
  "$${APP_IMAGE}"
START_SCRIPT

chmod 750 /usr/local/sbin/start-ecommerce
echo "Bootstrap complete. Add /opt/ecommerce/.env, then run sudo /usr/local/sbin/start-ecommerce."
