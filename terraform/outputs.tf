output "public_ip" {
  description = "Public IP of the ephemeral instance"
  value       = aws_instance.ci_ephemeral.public_ip
}
