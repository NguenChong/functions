#
# Форматирует стандартную дату Mikrotik
#
# Вызов: $fmtDate <Date to format> <Param>
#
# Params:
#     1    YYYYMMDD           для формирования имён файлов
#     2     DD.MM.YYYY        обычный формат даты
#     3     DD MMM
#
:global fmtDate do={

    :local M [:pick $1 0 3];
    :local D [:pick $1 4 6];
    :local Y [:pick $1 7 11];

    :log warning ("fmt " . $M);

    # :set $mts ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
    :set $mts ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");

    :set $month ([find $mts $M -1]+1);

    :log warning ("fmt " . $month);

    # Add leading zero if needed to Day
    :if ($D < 10) do {
        :set D ("0" . $D)
    }

    # Add leading zero if needed to Month
    :if ($month < 10) do {
        :set month ("0" . $month)
    }
    if ($2 = 1)  do={ :return ($Y . $month . $D) }
    if ($2 = 2)  do={ :return ($D . "." . $month . "." . $Y) }
    if ($2 = 3)  do={ :return ($D . " " . $M) }
}

#
#
# Params
#       1,2       Дата и время в формате Dude
#       3       Название устройства
#       4       Название сервиса
#       5       Статус сервиса
#
#
:global TelegramSend do={

    :global fmtDate;
    :local id 275142611:AAHcGomHPoZj98RqbhqR15v_KsyFtaNGbpQ
    :local chatid 299931895
    :local currDate;
    :local currTime [:pick $2 0 5];
    :local str

    :set $currDate [$fmtDate $1 3];

    # :log warning $1
    # :log warning $currDate

    :set str ("<b><u>" . $3 . "</u></b>: ");
    :set str ($str . $4 . " - " . "<b>" . $5 . "</b>%0A");
    :set str ($str . $currDate . "  " . $currTime);

    /tool fetch keep-result=no url=("https://api.telegram.org/bot" . $id . "/sendMessage\?chat_id=" . $chatid . \
        "&text=" . $str . "&parse_mode=HTML")

}
