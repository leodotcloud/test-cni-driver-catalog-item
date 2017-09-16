version: '2'
services:
  test-cni-driver:
    privileged: true
    image: leodotcloud/cni-driver:dev
    command: start-cni-driver.sh
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
    network_mode: host
    pid: host
    labels:
      io.rancher.scheduler.global: 'true'
      io.rancher.network.cni.binary: 'test-rancher-bridge'
      io.rancher.container.dns: 'true'
    volumes:
      - rancher-cni-driver:/opt/cni-driver
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    network_driver:
      name: Rancher Test CNI Network
      default_network:
        name: testcnidrivernetwork
        host_ports: true
        subnets:
        - network_address: 10.49.0.0/16
        dns:
        - 169.254.169.250
        dns_search:
        - rancher.internal
      cni_config:
        '10-testcnidriver.conf':
          name: rancher-cni-network
          type: test-rancher-bridge
          bridge: testcni0
          bridgeSubnet: 10.49.0.0/16
          logToFile: /var/log/rancher-cni.log
          isDebugLevel: ${RANCHER_DEBUG}
          isDefaultGateway: true
          hostNat: true
          ipam:
            type: rancher-cni-ipam
            subnetPrefixSize: /16
            logToFile: /var/log/rancher-cni.log
            isDebugLevel: ${RANCHER_DEBUG}
