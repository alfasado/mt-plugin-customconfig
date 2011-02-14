package CustomConfig::CustomConfig;
use strict;

use MT::Util qw( offset_time_list );

@CustomConfig::CustomConfig::ISA = qw( MT::Object );
__PACKAGE__->install_properties( {
    column_defs => {
        'id'            => 'integer not null auto_increment',
        'priority'      => 'integer',
        'author_id'     => 'integer',
        'name'          => 'string(255)',
        'key'           => 'string(255)',
        'value'         => 'string(255)',
        'created_on'    => 'datetime',
        'modified_on'   => 'datetime',
    },
    indexes => {
        'author_id'     => 1,
        'priority'      => 1,
        'name'          => 1,
        'key'           => 1,
        'value'         => 1,
        'created_on'    => 1,
        'modified_on'   => 1,
    },
    datasource  => 'customconfig',
    primary_key => 'id',
} );

sub class_label {
    my $plugin = MT->component( 'CustomConfig' );
    return $plugin->translate( 'Custom Config' );
}

sub class_label_plural {
    my $plugin = MT->component( 'CustomConfig' );
    return $plugin->translate( 'Custom Config' );
}

sub save {
    my $obj = shift;
    require MT::Log;
    my $app = MT->instance();
    my $plugin = MT->component( 'CustomConfig' );
    my $original;
    my $is_new;
    require MT::Author;
    require MT::Request;
    if ( is_cms( $app ) ) {
        if (! $app->user->is_superuser ) {
            $app->return_to_dashboard( permission => 1 );
            return 0;
        }
        my $ts = current_ts();
        if (! $obj->created_on ) {
            $obj->created_on( $ts );
        }
        $obj->modified_on( $ts );
        if ( $obj->id ) {
            my $author = MT::Author->load( $obj->author_id );
            if (! defined $author ) {
                $obj->author_id( $app->user->id );
            }
        } else {
            $obj->author_id( $app->user->id );
        }
        if ( $obj->id ) {
            $original = MT::Request->instance->cache( 'customconfig_original' . $obj->id );
            if (! $original ) {
                $original = $obj->clone_all();
            }
        }
    }
    if (! $obj->id ) {
        $is_new = 1;
    }
    $obj->SUPER::save( @_ );
    if ( $is_new ) {
        if ( $app->mode eq 'save' ) {
            $app->log( {
                message => $plugin->translate( 'Custom Config \'[_1]\' (ID:[_2]) created by \'[_3]\'', $obj->name, $obj->id, $app->user->name ),
                author_id => $app->user->id,
                class => 'customconfig',
                level => MT::Log::INFO(),
            } );
        }
    }
    if ( is_cms( $app ) ) {
        if ( $app->mode eq 'save' ) {
            if (! $is_new ) {
                $app->log( {
                    message => $plugin->translate( 'Custom Config \'[_1]\' (ID:[_2]) edited by \'[_3]\'', $obj->name, $obj->id, $app->user->name ),
                    author_id => $app->user->id,
                    class => 'customconfig',
                    level => MT::Log::INFO(),
                } );
            }
        }
    }
    return 1;
}

sub remove {
    my $obj = shift;
    if ( ref $obj ) {
        my $app = MT->instance();
        my $plugin = MT->component( 'CustomConfig' );
        if ( is_cms( $app ) ) {
            if (! $app->user->is_superuser ) {
                $app->return_to_dashboard( permission => 1 );
                return 0;
            }
        }
        $obj->SUPER::remove( @_ );
        if ( is_cms( $app ) ) {
            $app->log( {
                message => $plugin->translate( 'Custom Config \'[_1]\' (ID:[_2]) deleted by \'[_3]\'', $obj->name, $obj->id, $app->user->name ),
                author_id => $app->user->id,
                class => 'customconfig',
                level => MT::Log::INFO(),
            } );
            $app->run_callbacks( 'cms_post_delete.customconfig', $app, $obj, $obj );
        }
        return 1;
    }
    $obj->SUPER::remove( @_ );
}

sub author {
    my $obj = shift;
    require MT::Request;
    require MT::Author;
    my $r = MT::Request->instance;
    my $author = $r->cache( 'cache_author:' . $obj->author_id );
    return $author if defined $author;
    $author = MT::Author->load( $obj->author_id ) if $obj->author_id;
    unless ( defined $author ) {
        $author = MT::Author->new;
        my $plugin = MT->component( 'CustomConfig' );
        $author->name( $plugin->translate( '(Unknown)' ) );
        $author->nickname( $plugin->translate( '(Unknown)' ) );
    }
    $r->cache( 'cache_author:' . $obj->author_id, $author );
    return $author;
}

sub _nextprev {
    my ( $obj, $direction ) = @_;
    my $r = MT::Request->instance;
    my $nextprev = $r->cache( "customconfig_$direction:" . $obj->id );
    return $nextprev if defined $nextprev;
    $nextprev = $obj->nextprev(
        direction => $direction,
        terms     => { blog_id => $obj->blog_id },
        by        => 'created_on',
    );
    $r->cache( "customconfig_$direction:" . $obj->id, $nextprev );
    return $nextprev;
}

sub is_cms {
    my $app = shift || MT->instance();
    return ( ref $app eq 'MT::App::CMS' ) ? 1 : 0;
}

sub current_ts {
    my $blog = shift;
    my @tl = offset_time_list( time, $blog );
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $tl[5]+1900, $tl[4]+1, @tl[3,2,1,0];
    return $ts;
}

1;