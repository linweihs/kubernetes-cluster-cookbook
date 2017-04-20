#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

case node['platform']
when 'redhat', 'centos', 'fedora'
  # flannel is a virtual network that gives a subnet to each host for use with container runtimes.
  # Platforms like Kubernetes assume that each container (pod) has a unique, routable IP inside the cluster. 
  # The advantage of this model is that it reduces the complexity of doing port mapping.
  yum_package "flannel #{node['kubernetes_cluster']['package']['flannel']['version']}"
  yum_package "#{node['kubernetes_cluster']['package']['docker']['name']} #{node['kubernetes_cluster']['package']['docker']['version']}"
  yum_package "kubernetes-node #{node['kubernetes_cluster']['package']['kubernetes_node']['version']}"
  yum_package "bridge-utils #{node['kubernetes_cluster']['package']['bridge_utils']['version']}"
  service 'firewalld' do
    action [:disable, :stop]
  end
end

group 'kube-services'

directory node['kubernetes']['secure']['directory'] do
  only_if { node['kubernetes']['secure']['enabled'] == 'true' }
  owner 'root'
  group 'kube-services'
  mode '0770'
  recursive true
  action :create
end
