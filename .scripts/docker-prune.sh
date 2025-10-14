#!/bin/bash
# filepath: /home/Gautam/Projects/cerai/policybot/cleanup-docker.sh

echo "🧹 Starting Docker cleanup..."

# Stop all running containers
echo "⏹️  Stopping all running containers..."
if [ "$(docker ps -q)" ]; then
    docker stop $(docker ps -aq)
else
    echo "   No running containers found"
fi

# Remove all containers
echo "🗑️  Removing all containers..."
if [ "$(docker ps -aq)" ]; then
    docker rm $(docker ps -aq)
else
    echo "   No containers to remove"
fi

# Remove all images
echo "🖼️  Removing all images..."
if [ "$(docker images -aq)" ]; then
    docker rmi $(docker images -aq)
else
    echo "   No images to remove"
fi

# Remove all volumes
echo "💾 Removing all volumes..."
if [ "$(docker volume ls -q)" ]; then
    docker volume rm $(docker volume ls -q)
else
    echo "   No volumes to remove"
fi

# Remove all custom networks
echo "🌐 Removing all custom networks..."
if [ "$(docker network ls -q --filter type=custom)" ]; then
    docker network rm $(docker network ls -q --filter type=custom)
else
    echo "   No custom networks to remove"
fi

# Remove all build cache
echo "🔨 Removing build cache..."
docker builder prune -a -f

# Final system cleanup
echo "🧽 Final system cleanup..."
docker system prune -a -f --volumes

# Clean up buildx cache
echo "⚒️  Cleaning buildx cache..."
docker buildx prune -a -f

echo "✅ Docker cleanup complete!"
echo ""
echo "📊 Current Docker usage:"
docker system df
