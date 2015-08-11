###
# This is the place to override the unicorn cookbook's default attributes.
#
# Do not edit THIS file directly. Instead, create
# "unicorn/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
###

# The following shows how to override the Unicorn timout:
#
#normal[:unicorn][:timeout] = 30

deploy.keys do |application|
  if node[:deploy][application][:worker_processes]
    default[:unicorn][:worker_processes] = node[:deploy][application][:worker_processes]
  end
end
