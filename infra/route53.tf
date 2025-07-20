resource "aws_route53_record" "app" {
  zone_id = data.terraform_remote_state.infra_shared.outputs.primary_zone_id
  name    = "davidrstudios.com"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}
