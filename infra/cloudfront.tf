resource "aws_cloudfront_distribution" "static_site" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Static site for davidrstudios.com"

  aliases = ["davidrstudios.com"]

  origin {
    domain_name = aws_s3_bucket_website_configuration.static_site.website_endpoint
    origin_id   = "s3-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 300
    max_ttl                = 3600

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = data.terraform_remote_state.infra_shared.outputs.primary_acm_certificate_arn_us_east
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_root_object = "index.html"

  tags = var.tags
}

resource "aws_cloudfront_distribution" "www_redirect" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Redirect www.davidrstudios.com to apex"
  default_root_object = "index.html"

  aliases = ["www.davidrstudios.com"]

  origin {
    domain_name = aws_s3_bucket_website_configuration.www_redirect.website_endpoint
    origin_id   = "s3-www-redirect"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-www-redirect"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    min_ttl         = 0
    default_ttl     = 300
    max_ttl         = 3600

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.terraform_remote_state.infra_shared.outputs.primary_acm_certificate_arn_us_east
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags
}
