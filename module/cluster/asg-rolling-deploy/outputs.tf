output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value = aws_autoscaling_group.example.name
}

output "instance_security_group_id" {
  description = "The ID of the EC2 Instance Security Group"
  value = aws_security_group.instance.id
}
