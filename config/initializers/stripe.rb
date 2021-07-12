# frozen_string_literal: true
# :Stripe Configuration:
Rails.configuration.stripe = {
 publishable_key: ENV['pk_test_51J9oJASBnEsdstJlau4PLqep8UhZdT0sPN3YAyMWZQqxLMaAWoFdC1NAvcaJKGNOMb8A16RTohRKpNBnBRDMi4VC00QUyHeojK'],
 secret_key: ENV['sk_test_51J9oJASBnEsdstJlBPd81H1g5zqBHfScC8yix2SSUqPDzYTsTmP0IfDxlOJocQTYPgeh6jlPbfuVJGEkkeTUq4ie001Tnr610x']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]