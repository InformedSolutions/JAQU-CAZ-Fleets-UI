# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

#:nocov:
if Rails.env.production?
  cookie_control_url = %w[https://cc.cdn.civiccomputing.com]
  ga_urls = %w[https://www.googletagmanager.com https://www.google-analytics.com]
  defaults = %i[self https]
  defaults.push(ENV['CLOUDFRONT_ENDPOINT']) if ENV['CLOUDFRONT_ENDPOINT']

  Rails.application.config.content_security_policy do |policy|
    policy.default_src(:none)
    policy.font_src(*defaults, :data)
    policy.img_src(*defaults)
    policy.object_src(:none)
    policy.script_src("'sha256-d9c+dV7L1yNV9jTrn0dFU0w5wZTj02ZmtGQvaN8sHKg'",
                      "'sha256-73apBKpD7j/5bd3FmbyTrw01EqeBg2g8rxWzYeiQMXc'",
                      *defaults, *ga_urls, *cookie_control_url)
    policy.style_src("'sha256-YyWKU7sbALoSEpoibbWe4AvlJf320C6BhPPCJa3RxDo'",
                     "'sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU'",
                     "'sha256-0lDvsX2XtY61lNg5AvqH36/zyCtX0kJp8iZ8SDYaD1M'",
                     "'sha256-gvmjIxVcV84toBcOQoDyWM97YKhghJ5TKBOo76CCPFs'",
                     *defaults)
    policy.connect_src(*defaults)
    policy.frame_ancestors(:none)
  end
end

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator =
  ->(_request) { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
