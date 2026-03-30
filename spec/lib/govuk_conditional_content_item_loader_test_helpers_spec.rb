require "spec_helper"
require "gds_api"
require "ostruct"
require "rails"
require "govuk_content_item_loader"
require "govuk_content_item_loader/test_helpers"
require "webmock/rspec"

RSpec.describe GovukConditionalContentItemLoaderTestHelpers do
  include described_class

  let(:base_path) { "/some-base-path" }
  let(:config) do
    OpenStruct.new(
      graphql_allowed_schemas: %w[test_schema],
      graphql_traffic_rates: { "test_schema" => 1.0 },
    )
  end
  let(:content_item) do
    { "some_value" => 123 }
  end
  let(:request) do
    instance_double(
      ActionDispatch::Request,
      path: base_path,
      env: {},
      params: {},
    )
  end

  before do
    allow(Rails).to receive(:application).and_return(double(config: config))
  end

  describe ".stub_conditional_loader_returns_content_item_for_path" do
    before do
      stub_conditional_loader_returns_content_item_for_path(base_path, content_item)
    end

    it "includes the body in the response" do
      loader = GovukConditionalContentItemLoader.new(request:)
      expect(loader.load.to_hash).to eq(content_item)
    end
  end

  describe ".stub_conditional_loader_does_not_return_content_item_for_path" do
    before do
      stub_conditional_loader_does_not_return_content_item_for_path(base_path)
    end

    it "returns an error for the base path" do
      loader = GovukConditionalContentItemLoader.new(request:)
      expect { loader.load }.to raise_error(GdsApi::Base::ItemNotFound)
    end
  end
end
