from dagster_airbyte import load_assets_from_airbyte_instance, AirbyteResource

airbyte_instance = AirbyteResource(
    host='localhost', 
    port='8081',
)

airbyte_assets = load_assets_from_airbyte_instance(
    airbyte_instance,
    key_prefix='airbyte_asset',
)