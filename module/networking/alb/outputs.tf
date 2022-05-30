output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value = aws_lb.example.dns_name
}

output "alb_http_listener_arn" {
  description = "The ARN of the HTTP listener"
  value = aws_lb_listener.http.arn
}

output "alb_security_group_id" {
  description = "The ALB Security Group ID"
  value = aws_security_group.alb.id
}
