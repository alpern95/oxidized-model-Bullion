class Bullion < Oxidized::Model
  
  prompt /^[^#]+#/
  comment  '# '
  
  
  #add a comment in the final conf
  def add_comment comment
    "\n###### #{comment} ######\n" 
  end

  cmd :all do |cfg|
    cfg.each_line.to_a[1..-2].join
  end
  
  #show the persistent configuration
  pre do
    cfg = add_comment 'THE HOSTNAME'
    cfg += cmd 'cat /etc/hostname'
    
    cfg += add_comment 'THE HOSTS'
    cfg += cmd 'cat /etc/hosts'
    
    cfg += add_comment 'THE INTERFACES'
    cfg += cmd 'grep -r "" /etc/sysconfig/network-scripts/ifcfg-* | cut -d "/" -f 4-'
    
    cfg += add_comment 'RESOLV.CONF'
    cfg += cmd 'cat /etc/resolv.conf'
    
    cfg += add_comment 'NTP.CONF'
    cfg += cmd 'cat /etc/ntp.conf'

    cfg += add_comment 'CHRONY.CONF'
    cfg += cmd 'cat /etc/chrony.conf'
    
    cfg += add_comment 'IP Routes'
    cfg += cmd 'ip route'
    
    cfg += add_comment 'OVIRT-HOST-ENGINE-SETUP - ANSWER FILE'
    cfg += cmd 'cat /etc/ovirt-hosted-engine/answers.conf'
                
    cfg += add_comment 'MOTD'
    cfg += cmd 'cat /etc/motd'
    
    cfg += add_comment 'PASSWD'
    cfg += cmd 'cat /etc/passwd'
 
    cfg += add_comment 'SELINUX'
    cfg += cmd 'cat /etc/selinux/config'
       
    cfg += add_comment 'ACL'
    cfg += cmd 'iptables -L -n'
    
    cfg += add_comment 'VERSION'
    cfg += cmd 'cat /etc/redhat-release'

    cfg += add_comment 'KERNEL INFORMATION'
    cfg += add_comment '## kernel-release'
    cfg += cmd 'uname -r'
    cfg += add_comment '## machine'
    cfg += cmd 'uname -m'

    cfg += add_comment 'BOOT TYPE'
    boot = cmd 'dmesg | grep "EFI v"'
    unless boot.include? 'EFI'
	    boot = cmd 'cat /var/log/dmesg.old | grep -q "EFI v"'
	    unless boot.include? 'EFI'
	      cfg += cmd 'echo "Not EFI"'
	    else
	      cfg += cmd 'echo "Is EFI"'
	    end
    else
	    cfg += cmd 'echo "Is EFI"'
    end

    cfg += add_comment 'LISTE PAQUETS INSTALLES'
    cfg += cmd "rpm -qa --qf '%{NAME} %{VERSION} %{ARCH} rpm %{SUMMARY}\n' | sort"

  end
  
  cfg :ssh do
    pre_logout 'exit'
  end
 
end
