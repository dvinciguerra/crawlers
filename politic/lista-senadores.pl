#!/usr/bin/env perl 

use 5.10.0;
use strict;
use warnings;

# imports
use Mojo::JSON qw(encode_json);
use Mojo::IOLoop;
use Mojo::UserAgent;


my $ua = Mojo::UserAgent->new;

# alternativa http://www.senado.gov.br/senadores/senadoresPorUF.asp

my $data = [];
$ua->get(
  'http://www25.senado.leg.br/web/senadores/em-exercicio',
  sub {
    my ($ua, $tx) = @_;

    if (my $res = $tx->success) {
      $res->dom(
        'table#senadoresemexercicio-tabela-senadores tbody > tr:not(.search-group-row)'
        )->each(
        sub {
          my $cols = $_->find('td');
          push @$data,
            {
            name  => $cols->[0]->at('a')->text   || '',
            link  => $cols->[0]->at('a')->{href} || '',
            party => $cols->[1]->text            || '',
            state => $cols->[2]->text            || '',
            time  => $cols->[3]->text            || '',
            phone => $cols->[4]->text            || '',
            email => $cols->[5]->text            || '',
            };
        }
        );
    }
  }
);

# Start event loop if necessary
Mojo::IOLoop->start unless Mojo::IOLoop->is_running;

# output json data
say encode_json $data ;

