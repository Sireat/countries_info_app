// core/util/constants.dart

// ignore_for_file: constant_identifier_names

// Base URL for the API used to fetch country data.
const String BASE_URL = 'https://restcountries.com/v3.1';

// Endpoint for retrieving data of all countries.
// ignore: duplicate_ignore
// ignore: constant_identifier_names
const String ALL_COUNTRIES_ENDPOINT = '$BASE_URL/all';

// Endpoint for retrieving data of a specific country by its name.
// This endpoint expects a country name to be appended at the end of the URL.
const String COUNTRY_BY_NAME_ENDPOINT = '$BASE_URL/name/';

// Error message shown when a server connection fails.
const String SERVER_FAILURE_MESSAGE = 'Failed to connect to the server.';

// Error message shown when there is an issue loading data from cache.
const String CACHE_FAILURE_MESSAGE = 'Failed to load data from cache.';

// Duration for timeout used in HTTP requests, set to 30 seconds.
const Duration REQUEST_TIMEOUT = Duration(seconds: 30);

// Default error message used when an unexpected error occurs.
const String DEFAULT_ERROR_MESSAGE = 'An unexpected error occurred.';
