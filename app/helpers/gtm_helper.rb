# frozen_string_literal: true

module GtmHelper
  def google_tag_manager_script_tag
    gtm_id = ENV['GTM_ID']
    gtm_url_overrides = ENV['GTM_URL_OVERRIDES']

    url_overrides_attribute = gtm_url_overrides.present? ? "+\'#{gtm_url_overrides}\'" : ''

    <<~HTML.strip_heredoc.html_safe
      <!-- Google Tag Manager -->
      <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
      j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
      'https://www.googletagmanager.com/gtm.js?id='+i+dl#{url_overrides_attribute};f.parentNode.insertBefore(j,f);
      })(window,document,'script','dataLayer', '#{gtm_id}');</script>
      <!-- End Google Tag Manager -->
    HTML
  end

  def google_tag_manager_noscript_tag
    url_attribute = "#{ENV['GTM_ID']}#{ENV['GTM_URL_OVERRIDES']}"

    <<~HTML.strip_heredoc.html_safe
      <!-- Google Tag Manager (noscript) -->
      <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=#{url_attribute}"
      height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
      <!-- End Google Tag Manager (noscript) -->
    HTML
  end
end
