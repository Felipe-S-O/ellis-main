# Use an official Python runtime as a parent image
# A imagem `python:3.10-slim` é uma base leve que já inclui Python e pip.
FROM python:3.11.13-alpine3.22

# Set the working directory in the container
WORKDIR /app

# Create a non-root user and group for security purposes
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the dependencies file to the working directory
# This is done first to leverage Docker's layer caching
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's code to the working directory
COPY . .

# Change ownership of the app directory to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose port 8000 to the Docker network
EXPOSE 8000

# Command to run the application.
# O host 0.0.0.0 torna a aplicação acessível de fora do contêiner.
# Este é o comando padrão, que será sobrescrito pelo docker-compose.yml para desenvolvimento.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]