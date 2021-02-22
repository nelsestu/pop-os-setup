# identify your partitions
lsblk

# we want to mount a /boot/efi, /, and etc 
sudo mount /dev/nvme0n1p1 /mnt/boot/efi
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
sudo cp /etc/resolv.conf /mnt/etc/
# with everything mounted, we can now chroot 
sudo chroot /mnt

# if this all worked, you'll be logged in as root under the install you are trying to recover

sudo apt-get install ubuntu-dev-tools

# https://itectec.com/ubuntu/ubuntu-how-to-set-mount-point-of-boot-partition-to-boot-efi/
# the content of /etc/fstab will show what disks and partitions
# are loaded as a part of booting into the OS.  A common problem
# is that the partition /boot/efi/ has been reassigned a new 
# partition id.  If this happens edit fstab by hand, replacing the 
# UUID=22ac8da3-d60a... with either explicit partition path: /dev/nvme0n1p1 
# or by discovering the new UUID using the command: blkid

# there is a simple utility called groot, which will automatically mount 
# the partitions that you need for proper chroot session:
# https://teejeetech.in/2017/12/01/introducing-groot/#more-248

# as i write this the pop-planet forum is down, but I recall there being 
# particularly useful advice in a post here: https://pop-planet.info/wiki/index.php?title=REFInd#refind_linux.conf

# mount a usb drive for additional utilities during recovery.
# identify the path of your usb device
sudo lsusb # list the usb devices presently detected
sudo fdisk -l # looking for a partition something like: /dev/sdb1
# Create a mount point, aka a new directory in /media, where you'll mount the drive onto the filesystem:
sudo mkdir -p /media/usb
sudo mount /dev/sdb1 /media/usb
# can be unmounted with: sudo umount /media/usb

# more than you need to know about booting with efi
# http://www.rodsbooks.com/efi-bootloaders/installation.html