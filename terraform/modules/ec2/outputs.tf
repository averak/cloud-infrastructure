output "instance_id" {
  description = "EC2のインスタンスID"
  value       = aws_instance.main.id
}