output "instance_ip" {
  value       = aws_instance.main_instance.public_ip
  sensitive   = false
  description = "Public IP Address of main instance"
  depends_on  = []
}
