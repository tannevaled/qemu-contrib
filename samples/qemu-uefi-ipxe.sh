#!/usr/bin/env bash
#
#
#
VM_NAME="qemu-uefi-pxeboot"
#
# COMMANDS
#
QEMU="/usr/bin/qemu-system-x86_64"
QEMU_IMG="/usr/bin/qemu-img"
IMG_CREATE="${QEMU_IMG} create"
QEMU_BRIDGE_HELPER="/usr/libexec/qemu-bridge-helper"
#
# PATHES
#
NVRAMS="/var/lib/libvirt/qemu/nvram/"
OVMF_DIR="/usr/share/edk2/ovmf"
IMAGES="/var/lib/libvirt/images"
ROMFILE_DIR="/var/lib/libvirt/boot"
#
# ARCHITECTURE
#
MACHINE_TYPE="pc"
MACHINE="-machine type=${MACHINE_TYPE},accel=kvm"
CPU="-cpu host"
#
# UEFI
#
OVMF_CODE_FILE="${OVMF_DIR}/OVMF_CODE.fd"
OVMF_VARS_FILE_TEMPLATE="${OVMF_DIR}/OVMF_VARS.fd"
OVMF_VARS_FILE="#{NVRAMS}/${VM_NAME}_VARS.fd"
OVMF_CODE="-drive if=pflash,format=raw,readonly,file=${OVMF_CODE_FILE}"
OVMF_VARS="-drive if=pflash,format=raw,file=${OVMF_VARS_FILE}"
BIOS="${OVMF_CODE} ${OVMF_VARS}"
#
# MEMORY
#
MEMORY_SIZE=2G
MEMORY="-m size=${MEMORY_SIZE}"
#
# SYSTEM DISK
#
SYSTEM_ID="system_drive"
VM_IMAGE="${VM_NAME}"
VM_IMAGE_FORMAT=qcow2
VM_IMAGE_SIZE=40G
SYSTEM_FILE="${IMAGES}/${VM_IMAGE}.${VM_IMAGE_FORMAT}"
SYSTEM="-drive file=${SYSTEM_FILE},id=${SYSTEM_ID},format=${VM_IMAGE_FORMAT},if=virtio,cache=writeback"
#
# NETWORK ROMFILE
# leave empty to netboot it!
# !!! note that ipxe hangs on device initialisation in that case since
# septembre 2015 !!!
#
NETWORK_ROMFILE_NAME="virtio-net.efirom"
NETWORK_ROMFILE_PATH="${ROMFILE_DIR}/${NETWORK_ROMFILE_NAME}"
NETWORK_ROMFILE="romfile=${NETWORK_ROMFILE_PATH}"
NETWORK_DEVICE_NAME="vnet0"
NETWORK_DEVICE="netdev=${NETWORK_DEVICE_NAME}"
NETWORK_MAC_ADDR="00:12:34:56:78:9a"
NETWORK_MAC="mac=${NETWORK_MAC_ADDR}"
NETWORK_BRIDGE_NAME="br_client"
NETWORK_BRIDGE="br=${NETWORK_BRIDGE_NAME}"
NETWORK_BRIDGE_HELPER="helper=$QEMU_BRIDGE_HELPER"
NETWORK_DEVICE="-device virtio-net-pci,${NETWORK_ROMFILE},${NETWORK_DEVICE},${NETWORK_MAC}"
NETWORK_BRIDGE="-netdev bridge,id=${NETWORK_DEVICE_NAME},${NETWORK_BRIDGE},$NETWORK_BRIDGE_HELPER"
NETWORK="${NETWORK_DEVICE} ${NETWORK_BRIDGE}"
#
#
#
cp ${OVMF_VARS_FILE_TEMPLATE} ${OVMF_VARS_FILE}
rm ${SYSTEM_FILE}
${IMG_CREATE} -f ${VM_IMAGE_FORMAT} -o size=${VM_IMAGE_SIZE} ${SYSTEM_FILE}
#
# START THE VM
#
${QEMU} ${MACHINE} ${CPU} ${BIOS} ${MEMORY} ${SYSTEM} ${NETWORK}
