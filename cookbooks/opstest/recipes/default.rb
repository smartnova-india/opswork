#
# Cookbook:: opstest
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
include_recipe "opstest::override_node"
Chef::Log.info("Starting Default Recipe")

Chef::Log.info("Platform: #{node[:platform]}")

Chef::Log.info("NODE1: #{Chef::JSONCompat.to_json_pretty(node.to_hash)}")

Chef::Log.info("=============================")
Chef::Log.info("End Default Recipe")