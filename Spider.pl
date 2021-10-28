#!/usr/bin/perl -X

##########################
use WWW::Mechanize;
use threads;
use threads::shared;
use Term::ANSIColor;
##########################


# Autor Rafael Gomes da Silva
# Email rafaelgomes38@hotmail.com
# www.linkedin.com/in/rafaelgms/
# www.rafaelgms.com
# Licensa GPL
# Arte AsCII obtida em https://www.asciiart.eu/animals/spiders

my @lst = ();
my %seen = ();
my $url;

my $url = $ARGV[0];
my $TdLs = "(com|com.br|net|net.br|edu|org|uk|co.uk|af|al|dz|as|ad|ao|ai|aq|ag|ar|am|aw|au|at|az|bs|bh|bd|bb|by|be|bz|bj|bm|bt|bo|ba|bw|bv|br|io|bn|bg|bf|bi|kh|cm|ca|cv|ky|cf|td|cl|cn|cx|cc|co|km|cg|cd|ck|cr|ci|hr|cy|cz|dk|dj|dm|do|tl|ec|eg|sv|gq|er|ee|et|fk|fo|fj|fi|fr|gf|pf|tf|ga|gm|ge|de|gh|gi|gr|gl|gd|gp|gu|gt|gn|gw|gy|ht|hm|hn|hk|hu|is|in|id|iq|ie|il|it|jm|jp|jo|kz|ke|ki|kw|kg|la|lv|lb|ls|lr|ly|li|lt|lu|mo|mk|mg|mw|my|mv|ml|mt|mh|mq|mr|mu|yt|mx|fm|md|mc|mn|ms|ma|mz|na|nr|np|nl|an|nc|nz|ni|ne|ng|nu|nf|mp|no|om|pk|pw|ps|pa|pg|py|pe|ph|pn|pl|pt|pr|qa|re|ro|ru|rw|kn|lc|vc|ws|sm|st|sa|sn|cs|sc|sl|sg|sk|si|sb|so|za|gs|kr|es|lk|sh|pm|sr|sj|sz|se|ch|tw|tj|tz|th|tg|tk|to|tt|tn|tr|tm|tc|tv|ug|ua|ae|gb|us|um|uy|uz|vu|va|ve|vn|vg|vi|wf|eh|ye|zm|zw|xyz)";

system("echo - > sitelist.txt"); #Cria ou limpa o arquivo sitelist.txt

    if ($url eq '') {
        print q{
              (
              )
              (
        /\  .-"""-.  /\
       //\\/  ,,,  \//\\
       |/\| ,;;;;;, |/\|
       //\\\;-"""-;///\\
      //  \/   .   \/  \\
     (| ,-_| \ | / |_-, |)
       //`__\.-.-./__`\\
      // /.-(() ())-.\ \\
     (\ |)   '---'   (| /)
      ` (|           |) `
        \)           (/

Perl spider crawler.
};
        print "Usage perl $0 www.example.com \n";
           exit(0);
    } else {
        &Scann($url);
      }


  sub Scann() {
    $url = $_[0];
      if($url =~ m/(http|https):\/\//sig){
      } else {
        $url = "http://".$url;
      }
      
    my $filename = "sitelist.txt";
       open(my $fh, '<:encoding(UTF-8)', $filename) or &sitelist($url); #die "Erro '$filename' $!";
          while (my $row = <$fh>) {
            chomp $row;
               if ($url eq $row) {
                #print "SITELIST => $url\n";
                exit(0);
               }
          }
          
    print "Crawling => $url\n";
      &sitelist($url);
      
              my $mech=WWW::Mechanize->new(stack_depth=>0,timeout=>10,autocheck=>0,);
                     $mech->timeout(10);
                       $mech->agent('Mozilla/5.0 (X11; Linux i686; rv:64.0) Gecko/20100101 Firefox/64.0');
                        my $response = $mech->get("$url");
                          if ($response->is_success) {
                              $rpx = $mech->content;
                                $domain = &cleanDomain($url);
                                  chomp($domain);
                                    $rgx = get_url($url);
                                    
                                      while ($rpx =~ m/href="(.*?)"/gm){
                                        if ($url =~ /((\w+:\/\/)[-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+)/gm) {
                                        #Void...
                                        } else {
                                             my $rgxr = $rgx."/$1";          
                                                if ($rgxr =~ /((\w+:\/\/)[-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+https?:\/\/(.*))/gm) {
                                                  $rgxr = "Erro";
                                                  $newlink = $2.$3;            
                                                  #print "[NW] = $newlink\n";
                                                    if ($newlink=~ /.?$domain.$TdLs/gm) {
                                                      push(@lst, "$newlink\n");
                                                    }
                                                }
                                          push(@lst, "$rgxr\n") unless $rgxr eq 'Erro';
                                              }
                                      }
                                      
                                      while ($rpx =~ m/href='(.*?)'/gi){
                                        if ($url =~ /((\w+:\/\/)[-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+)/gm) {
                                        #Void...
                                        } else {
                                             my $rgxr = $rgx."/$1";          
                                                if ($rgxr =~ /((\w+:\/\/)[-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+https?:\/\/(.*))/gm) {
                                                  $rgxr = "Erro";
                                                  $newlink = $2.$3;            
                                                  #print "[NW] = $newlink\n";
                                                    if ($newlink=~ /.?$domain.$TdLs/gm) {
                                                      push(@lst, "$newlink\n");
                                                    }
                                                }
                                          push(@lst, "$rgxr\n") unless $rgxr eq 'Erro';
                                              }
                                      }
                                      
                                      while ($rpx =~ /((\w+:\/\/)[-a-zA-Z0-9:@;?&=\/%\+\.\*!'\(\),\$_\{\}\^~\[\]`#|]+)/gm) {
                                        if (!$1 eq '') {
                                           $cmp = $1;
                                            if ($cmp =~ /.?$domain.$TdLs/gm) {          
                                              push(@lst, "$cmp\n");
                                            }
                                        }
                                      }
                            ###########
                            &SqL($url);
                            ###########
                              foreach my $rbl (@lst) {
                                chomp($rbl);
                                  unless ($seen{$rbl}++) {
                                    $ps = `ps aux|grep perl|wc -l`;
                                      if ($ps >=100) {
                                        sleep(20);
                                      }
                                      if ($ps >= 200) {
                                        sleep(60);
                                      }
                                    sleep(1);
                                      if (my $pid = fork) { waitpid($pid, 0); }
                                        else { if (fork) { exit; } else {
                                              &Scann($rbl);    
                                      } exit; }
                                    
                                  }
                              }
                          } else {
                          die $response->status_line;
                          }
  }

  sub sitelist() {
    my $site=$_[0];
    open(LOG,">>sitelist.txt") || die "Can't open file\n";
      print LOG "$site\n"; 				
    close(LOG);
  }

  sub cleanDomain(){
    my $site=$_[0];
      if ($site =~ /https/) { substr($site, 0, 8) = ""; }
      if ($site =~ /http/) { substr($site, 0, 7) = ""; }
      if ($site =~ /ftp/) { substr($site, 0, 6) = ""; }
      if ($site =~ /www\./) { substr($site, 0, 4) = ""; }
      if ($site =~ /www2\./) { substr($site, 0, 5) = ""; }
      if ($site =~ /forum\./) { substr($site, 0, 6) = ""; }
      $pos = index($site,'.');
      $nomesite = substr($site,0,$pos);
    return $nomesite;
  }

  sub get_url(){
    my $urlX = shift;
      if($urlX =~/http:\/\//){
        $urlX =~s/http:\/\///g;
        $urlX = substr($urlX, 0, index($urlX, '/')) if($urlX =~/\//);
      return "http://" . $urlX;
    }
    if($urlX =~/https:\/\//){
        $urlX =~s/https:\/\///g;
        $urlX =  substr($urlX, 0, index($urlX, '/')) if($urlX =~/\//);
      return "https://" . $urlX;
    }
  }

  sub Msg() {
    my $url = $_[0];
    print colored(['red'], "[ Scan ] = $url => SqL VulN", "\n");
  }

# Subrotina para realizar uma verificacao basica de SQL

  sub SqL() {
    my $url = $_[0];
      if($url =~ /(http|https):\/\/(.*?)\/(.*)[=?]/sig){
        my $url = $url."'";
          my $mech=WWW::Mechanize->new(stack_depth=>0,timeout=>10,autocheck=>0,);
            $mech->timeout(10);
              $mech->agent('Mozilla/5.0 (X11; Linux i686; rv:64.0) Gecko/20100101 Firefox/64.0');
                my $response = $mech->get("$url");
                  if ($response->is_success) {
                    $rpx = $mech->content;
                      if ($rpx =~ m/You have an error in your SQL syntax/i || $rpx =~ m/Query failed/i || $rpx =~ m/SQL query failed/i ) {
                             &Msg($url);
                      } elsif ($rpx =~ m/ODBC SQL Server Driver/i || $rpx =~ m/Unclosed quotation mark/i || $rpx =~ m/Microsoft OLE DB Provider for/i ) {
                             &Msg($url);
                      } elsif ($rpx =~ m/Microsoft JET Database/i || $rpx =~ m/ODBC Microsoft Access Driver/i || $rpx =~ m/Microsoft OLE DB Provider for Oracle/i ) {
                             &Msg($url);
                      } elsif ($rpx =~ m/mysql_/i || $rpx =~ m/Division by zero in/i || $rpx =~ m/mysql_fetch_array/i ) {
                            &Msg($url);
                      }
                  } else {
                    die $response->status_line;
                  }
      }
  }

