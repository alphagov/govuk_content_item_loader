require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/content_store"
require "gds_api/test_helpers/publishing_api"

module GovukConditionalContentItemLoaderTestHelpers
  include GdsApi::TestHelpers::ContentStore
  include GdsApi::TestHelpers::PublishingApi

  def stub_conditional_loader_returns_content_item_for_path(base_path, body = content_item_for_base_path(base_path), options = {})
    stub_content_store_has_item(base_path, body, options)
    stub_publishing_api_graphql_has_item(base_path, body, options)
  end

  def stub_conditional_loader_does_not_return_content_item_for_path(base_path, options = {})
    stub_content_store_does_not_have_item(base_path, options)
    stub_publishing_api_graphql_does_not_have_item(base_path)
  end

  def stub_conditional_content_loader_isnt_available
    stub_content_store_isnt_available
    stub_publishing_api_isnt_available
  end

  def stub_conditional_content_loader_has_gone_item(base_path)
    stub_content_store_has_gone_item(base_path)
    stub_publishing_api_graphql_has_gone_item(base_path)
  end

private

  def content_item_for_base_path(base_path)
    include GdsApi::TestHelpers::ContentItemHelpers

    super.merge("base_path" => base_path)
  end
end
