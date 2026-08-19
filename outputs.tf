output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "URL para ver Nginx funcionando"
  value       = "http://${aws_instance.web.public_ip}"
}