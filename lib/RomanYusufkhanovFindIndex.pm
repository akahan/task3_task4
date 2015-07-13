=encoding utf8

=cut

package RomanYusufkhanovFindIndex;

use Modern::Perl;


=head1 METHODS

=over

=cut

=item new

=cut

sub new {
    my ( $class, %param ) = @_;
    return bless {}, $class;
}

=item find

Поиск в array индекс наиболее приближенного значения value.
Array должен быть отсортирован по возрастанию значений.

=cut

sub find {
    my ( $self, $array, $value ) = @_;

    my $begin = 0; # Начало интервала поиска
    my $end   = @$array - 1; # Конец интервала поиска
    my $iter  = 0; # Шаг поиска

    while ( $begin < $end ) {
        my $mid = int( ( $begin + $end ) / 2 );

        $iter++; 

        # say sprintf "b: %u, e: %u, m: %u", $array->[$begin], $array->[$end], $array->[$mid];

        # Значение найдено
        if ( $array->[$mid] == $value ) {
            return ( $mid, $iter );
        }

        # Искомое значение вне интервала, прерываем
        if ( $array->[$begin] >= $value ) {
            $end = $begin;
            last;
        }

        # Искомое значение вне интервала, прерываем
        if ( $array->[$end] <= $value ) {
            $begin = $end;
            last;
        }

        if ( $array->[$mid] > $value ) {
            $end = $mid;
        }
        else { 
            $begin = $mid + 1;
        }
    }

    # say sprintf "b: %u, e: %u\n", $array->[$begin], $array->[$end];

    # Ищем наиболее близкое значение
    if ( $end > 0 && $value - $array->[$begin - 1] <= $array->[$end] - $value ) {
        return ( $begin - 1, $iter );
    }
    else {
        return ( $end, $iter );
    }
}

=back

=cut

1;

