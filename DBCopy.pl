#!/usr/bin/perl

use DBI;
use Term::ProgressBar 2.00;

# connect to the server
my $dbh_source = DBI->connect("dbi:ODBC:Driver={SQL Server};Server=sqllon03\\it;Database=WANO_Staging;uid=PIDBConnect;pwd=Wan0\$PIDB") || die $DBI::errstr;
# connect to the local SQLIte
my $dbh_target = DBI->connect("dbi:SQLite:dbname=PI.sqlite") or die $DBI::errstr;

my @table;
my $t = $dbh_source->table_info(undef, undef, undef, "TABLE");
while ( my( $qual, $owner, $name, $type ) = $t->fetchrow_array()) {
    if ($owner == 'dbo' and $name =~ m/PI_/){
	$table = "$qual.$owner.$name";
	push(@table,($table));
    }
}

#print "@table\n";
foreach $table (@table) {copy_table($table);}

$dbh_source->disconnect();
$dbh_target->disconnect();


###############################

sub copy_table {
    my ($table) = @_;
    $table =~ m/(PI\w+)$/;
    my $name = $1;
    print "\n$table\n";
    # get fields name
    my $sth = $dbh_source->prepare("SELECT * FROM $table WHERE 1=0");
    $sth->execute();
    my $fields = $sth->{NAME};
    $fields = join(',',@{$fields});
    $fields = '('.$fields.')';
    $dbh_target->do("drop table if exists $name");
    $dbh_target->do("create table $name $fields");
    @ary = $dbh_source->selectall_array("select * from $table");
    my $len = @ary;
    my $pos = 0;
    my $progress = Term::ProgressBar->new($len);
    # copy table by row
    foreach (@ary) {
	$row = join("','", @{$_});
	$row = "('".$row."')";
	$dbh_target->do("insert into $name values $row");
	$progress->update($pos++);
    }
}
