# <center>Win 硬盘挂载</center>

> 双系统 NTFS 互写的情况下, 很容易出现数据丢失,  
> 尤其当 Windows 开启了 "快速启动" 功能.  
> 因此这个脚本的挂载设置为 "只读"

---

双系统不想改 `/etc/fstab` 开机默认挂载 Windows 硬盘, 改为手动选择挂载.

以下操作适用于 KDE 环境

**使用需要修改部分**: sh 文件的挂载硬盘信息, desktop 文件的路径

1. 保存脚本  
`mkdir -p ~/.local/bin`  
`vim ~/.local/bin/mount_win.sh`  
`chmod +x ~/.local/bin/mount_win.sh`

```bash
#!/bin/bash
set -euo pipefail

# ===================== config ======================
declare -a PARTITIONS=(
  "/dev/nvme0n1p4|/mnt/d"
  "/dev/nvme0n1p5|/mnt/e"
)
MOUNT_OPTS="uid=1000,gid=1000,ro"
# ===================================================

# 挂载单个分区
mount_partition() {
  local dev="$1"
  local mnt="$2"
  if grep -qs " $mnt " /proc/mounts; then
    echo "[$mnt] 已经挂载，跳过"
    return
  fi
  if grep -qs " $dev " /proc/mounts; then
    echo "[$dev] 已被挂载到其他位置，跳过 $mnt"
    return
  fi
  mkdir -p "$mnt"
  # ntfs只读, ntfs3可读写
  sudo mount -t ntfs "$dev" "$mnt" -o "$MOUNT_OPTS"
  echo "[$mnt] 挂载成功"
}

# 卸载单个分区
umount_partition() {
  local mnt="$1"
  if grep -qs " $mnt " /proc/mounts; then
    sudo umount "$mnt"
    echo "[$mnt] 已卸载"
  else
    echo "[$mnt] 未挂载，无需操作"
  fi
}

# ======== 交互式输入 ========
while true; do
  read -rp "请输入操作 [1=挂载, 2=卸载]: " ACTION
  if [[ "$ACTION" == "1" || "$ACTION" == "2" ]]; then
    break
  else
    echo "输入无效，请输入 1 或 2"
  fi
done

case "$ACTION" in
1)
  echo "开始挂载 Windows NTFS 分区..."
  for entry in "${PARTITIONS[@]}"; do
    [[ -n "$entry" ]] || continue
    IFS='|' read -r dev mnt <<<"$entry"
    mount_partition "$dev" "$mnt"
  done
  ;;
2)
  echo "开始卸载 Windows NTFS 分区..."
  for ((i = ${#PARTITIONS[@]} - 1; i >= 0; i--)); do
    entry="${PARTITIONS[i]}"
    [[ -n "$entry" ]] || continue
    IFS='|' read -r dev mnt <<<"$entry"
    umount_partition "$mnt"
  done
  ;;
esac

echo "所有操作完成"
echo
read -n1 -rsp $'操作完成，按任意键退出...'
```

2. 编辑菜单文件: `vim ~/.local/share/applications/mount_win.desktop`

```ini
[Desktop Entry]
Type=Application
Name=Win挂载
Comment=交互式挂载或卸载 Windows NTFS 分区
Exec=bash ~/.local/bin/mount_win.sh
Icon=drive-harddisk
Terminal=true
Categories=Utility;
```
