package CustomConfig::Plugin;
use strict;

use MT::Util qw( format_ts );
use MT::I18N qw( substr_text length_text );

sub _init_tags {
    my $app = shift;
    my $core = MT->component( 'customconfig' );
    my $registry = $core->registry( 'tags', 'function' );
    require CustomConfig::CustomConfig;
    my @cfgs = CustomConfig::CustomConfig->load( { name => { like => 'MT%'} } );
    for my $cfg ( @cfgs ) {
        my $tag = $cfg->name;
        $tag =~ s/^mt//i;
        $tag =~ s/://g;
        $tag = lc( $tag );
        # TODO::Add Conditional Tag.
        $registry->{ $tag } = sub { 
            my ( $ctx, $args, $cond ) = @_;
            # TODO::Date type column.
            my $column = $args->{ column };
            $column = 'value' unless $column;
            $column = lc( $column );
            if ( $cfg && $cfg->has_column( $column ) ) {
                return $cfg->$column;
            }
        };
    }
}

sub _pre_run {
    my ( $cb, $app ) = @_;
    if (! $app->blog ) {
        my $usermenu = MT->component( 'UserMenu' );
        my $powercms = MT->component( 'PowerCMS' );
        if ( $usermenu || $powercms ) {
            my $menus = MT->registry( 'applications', 'cms', 'menus' );
            $menus->{ 'settings:list_customconfig' }->{ view } = [ 'user', 'system' ];
        }
    }
    return 1;
}

sub _list_customconfig {
    require File::Spec;
    my $plugin = MT->component( 'CustomConfig' );
    my $app = shift;
    my $user  = $app->user;
    my $mode = $app->mode;
    my $list_id = 'customconfig';
    if ( defined $app->blog ) {
        $app->return_to_dashboard( redirect => 1 );
    }
    if (! $app->user->is_superuser ) {
        $app->return_to_dashboard( permission => 1 );
    }
    my $code = sub {
        my ( $obj, $row ) = @_;
        my $columns = $obj->column_names;
        for my $column ( @$columns ) {
            my $val = $obj->$column;
            if ( $column =~ /_on$/ ) {
                $row->{ $column . '_raw' } = $val;
                $val = format_ts( "%Y&#24180;%m&#26376;%d&#26085;", $val, undef,
                                  $app->user ? $app->user->preferred_language : undef );
            } else {
                $row->{ $column . '_raw' } = $val;
                $val = substr_text( $val, 0, 22 ) . ( length_text( $val ) > 22 ? "..." : "" );
            }
            $row->{ $column } = $val;
        }
        my $obj_author = $obj->author;
        $row->{ author_name } = $obj_author->name;
    };
    my %terms;
    my %param;
    $app->{ plugin_template_path } = File::Spec->catdir( $plugin->path, 'tmpl' );
    $param{ list_id } = $list_id;
    $param{ system_view }  = 1;
    $param{ LIST_NONCRON } = 1;
    $param{ search_label } = MT->translate( 'Entry' );
    $param{ search_type }  = 'entry';
    $param{ saved_deleted }  = 1 if $app->param( 'saved_deleted' );
    $param{ saved }  = 1 if $app->param( 'saved' );
    return $app->listing (
        {
            type   => $list_id,
            code   => $code,
            args   => { sort => 'priority', direction => 'descend' },
            params => \%param,
            terms  => \%terms,
        }
    );
}

sub _hdlr_customconfig_loop {
    my ( $ctx, $args, $cond ) = @_;
    my $tag = $ctx->stash( 'tag' );
    require CustomConfig::CustomConfig;
    my $tokens = $ctx->stash( 'tokens' );
    my $builder = $ctx->stash( 'builder' );
    my $key = $args->{ key };
    my $name = $args->{ name };
    my $value = $args->{ value };
    my $id = $args->{ id };
    my $priority = $args->{ priority };
    my $terms;
    $terms->{ key } = $key if $key;
    $terms->{ name } = $key if $name;
    $terms->{ value } = $value if $value;
    $terms->{ id } = $id if $id;
    $terms->{ priority } = $priority if $priority;
    my $lastn = $args->{ lastn };
    $lastn = 9999 unless $lastn;
    if ( $tag eq 'CustomConfig' ) {
        $lastn = 1;
    }
    my $offset = $args->{ offset };
    $offset = 0 unless $offset;
    my $sort_by = $args->{ sort_by };
    $sort_by = 'priority' unless $sort_by;
    my $sort_order = $args->{ sort_order };
    $sort_order = 'descend' unless $sort_order;
    my $extra = { limit => $lastn,
                  offset => $offset,
                  sort => $sort_by,
                  direction => $sort_order, };
    my @customconfig = CustomConfig::CustomConfig->load( $terms, $extra );
    my $i = 0; my $res = '';
    my $odd = 1; my $even = 0;
    for my $config ( @customconfig ) {
        local $ctx->{ __stash }{ customconfig } = $config;
        local $ctx->{ __stash }->{ vars }->{ __first__ } = 1 if ( $i == 0 );
        local $ctx->{ __stash }->{ vars }->{ __counter__ } = $i + 1;
        local $ctx->{ __stash }->{ vars }->{ __odd__ } = $odd;
        local $ctx->{ __stash }->{ vars }->{ __even__ } = $even;
        local $ctx->{ __stash }->{ vars }->{ __last__ } = 1 if ( !defined( $customconfig[ $i + 1 ] ) );
        my $out = $builder->build( $ctx, $tokens, $cond );
        if ( !defined( $out ) ) { return $ctx->error( $builder->errstr ) };
        $res .= $out;
        if ( $odd == 1 ) { $odd = 0 } else { $odd = 1 };
        if ( $even == 1 ) { $even = 0 } else { $even = 1 };
        $i++;
    }
    return $res;
}

sub _hdlr_customconfig_column {
    my ( $ctx, $args, $cond ) = @_;
    return unless $ctx;
    my $tag = $ctx->stash( 'tag' );
    $tag =lc( $tag );
    $tag =~ s/^customconfig//i;
    if ( $tag =~ /.id$/i ) {
        $tag =~ s/id/_id/i;
    }
    my $config = $ctx->stash( 'customconfig' );
    return '' unless $config;
    if ( $config->has_column ( $tag ) ) {
        return $config->$tag || '';
    }
    return '';
}

sub _hdlr_customconfig_date {
    my ( $ctx, $args, $cond ) = @_;
    my $tag = $ctx->stash( 'tag' );
    $tag =~ s/^customconfig//i;
    $tag =~ s/on$//i;
    $tag =lc( $tag ) . '_on';
    my $config = $ctx->stash( 'customconfig' );
    return '' unless $config;
    if ( $config->has_column ( $tag ) ) {
        my $date = $config->$tag;
        $args->{ ts } = $date;
        $date = $ctx->build_date( $args );
        return $date || '';
    }
    return '';
}

sub _hdlr_author_displayname {
    my ( $ctx, $args, $cond ) = @_;
    my $config = $ctx->stash( 'customconfig' );
    return '' unless defined $config;
    my $author_name = $config->author->nickname;
    $author_name = $config->author->name unless $author_name;
    return $author_name;
}

1;