require "json"

module GovukConditionalContentItemLoaderTestHelpers
  Response = Struct.new(:status, :body, :headers) do
    def to_h
      JSON.parse(body)
    end
  end

  # Stubs the loader returns a content item
  # The following options can be passed in:
  #
  #   :max_age  will set the max-age of the Cache-Control header in the response. Defaults to 900
  #   :private  if true, the Cache-Control header will include the "private" directive. By default it
  #             will include "public"
  def stub_conditional_loader_returns_content_item(body, options = {})
    body.to_json unless body.is_a?(String)
    max_age = options.fetch(:max_age, 900)
    visibility = options[:private] ? "private" : "public"

    response = Response.new(200, body, {
      cache_control: "#{visibility}, max-age=#{max_age}",
      date: Time.now.httpdate,
    })

    loader = instance_double(GovukConditionalContentItemLoader, load: response)

    allow(GovukConditionalContentItemLoader).to receive(:new).with(request: anything)
      .and_return(loader)
    allow(loader).to receive(:load).and_return(body)

    response
  end

  # Stubs the loader returns a error response
  # The following options can be passed in:
  #
  #   :status         the HTTP status code for the error. Defaults to 404
  #   :message        the error message. Defaults to "Not Found"
  #   :error_details  optional additional error details to attach to the exception
  #   :http_body      optional raw response body to attach to the exception
  def stub_conditional_loader_does_not_return_content_item(options = {})
    status = options.fetch(:status, 404)
    message = options.fetch(:message, "Not Found")
    error_details = options[:error_details]
    http_body = options[:http_body]

    error = GdsApi::HTTPErrorResponse.new(status, message, error_details, http_body)

    loader = instance_double(GovukConditionalContentItemLoader)

    allow(GovukConditionalContentItemLoader).to receive(:new).with(request: anything)
      .and_return(loader)
    allow(loader).to receive(:load).and_raise(error)

    error
  end
end
