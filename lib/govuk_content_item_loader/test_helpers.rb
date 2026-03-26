require "json"

module GovukConditionalContentItemLoaderTestHelpers
  CONTENT_STORE_ENDPOINT = Plek.find("content-store")
  PUBLISHING_API_ENDPOINT = Plek.find("publishing-api")

  # Stubs the loader returns a content item
  # The following options can be passed in:
  #
  #   :max_age  will set the max-age of the Cache-Control header in the response. Defaults to 900
  #   :private  if true, the Cache-Control header will include the "private" directive. By default it
  #             will include "public"
  def stub_conditional_loader_returns_content_item(body, options = {})
    body = body.is_a?(String) ? body : body.to_json
    max_age = options.fetch(:max_age, 900)
    visibility = options[:private] ? "private" : "public"

    [CONTENT_STORE_ENDPOINT, PUBLISHING_API_ENDPOINT].each do |endpoint|
      stub_request(:get, %r{#{Regexp.escape(endpoint)}}).to_return(
        status: 200,
        body: body,
        headers: {
          "Cache-Control" => "#{visibility}, max-age=#{max_age}",
          "Date" => Time.now.httpdate,
        },
      )
    end

    loader = instance_double(GovukConditionalContentItemLoader, load: JSON.parse(body))

    allow(GovukConditionalContentItemLoader).to receive(:new).with(request: anything)
      .and_return(loader)
  end

  # Stubs the loader returns a simple HTTP error response
  # The following options can be passed in:
  #
  #   :status         the HTTP status code for the error. Defaults to 404
  def stub_conditional_loader_does_not_return_content_item(options = {})
    [CONTENT_STORE_ENDPOINT, PUBLISHING_API_ENDPOINT].each do |endpoint|
      stub_request(:get, %r{#{Regexp.escape(endpoint)}}).to_return(
        status: options.fetch(:status, 404),
        headers: {},
      )
    end
  end
end
