box::use(
  pbapply[
    pblapply
  ]
)

box::use(
  utils/api_utils[
    generate_endpoints,
    process_store_get_api
  ],
)

pblapply(
  generate_endpoints(),
  process_store_get_api
)
