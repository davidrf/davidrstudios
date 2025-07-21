resource "aws_route53_record" "apex" {
  zone_id = data.terraform_remote_state.infra_shared.outputs.primary_zone_id
  name    = "davidrstudios.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_alias" {
  zone_id = data.terraform_remote_state.infra_shared.outputs.primary_zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.www_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}
