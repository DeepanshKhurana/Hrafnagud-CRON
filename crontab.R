box::use(
  pbapply[
    pblapply
  ]
)

box::use(
  utils/api_utils[
    generate_endpoints,
    process_get_api
  ],
)

pblapply(
  generate_endpoints(),
  process_get_api
)
