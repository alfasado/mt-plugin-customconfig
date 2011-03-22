<?php
    global $mt;
    $ctx = &$mt->context();
    require_once 'class.mt_customconfig.php';
    $_customconfig = new CustomConfig;
    $where = "customconfig_name LIKE 'MT%'";
    $_customconfig = $_customconfig->Find( $where, false, false );
    if ( is_array( $_customconfig ) ) {
        foreach ( $_customconfig as $cfg ) {
            $name = $cfg->name;
            $name = preg_replace( '/^mt/i', '', $name );
            $name = strtr( $name, ':', '' );
            $name = strtolower( $name );
            $ctx->add_tag( $name, 'function_customconfig_tag' );
            $ctx->stash( "___customconfig:{$name}", $cfg );
            // TODO::Add Conditional Tag.
        }
    }
    function function_customconfig_tag ( $args, &$ctx ) {
        // TODO::Date type column.
        $name = $ctx->this_tag();
        $name = preg_replace( '/^mt/i', '', $name );
        $cfg = $ctx->stash( "___customconfig:{$name}" );
        if ( isset( $cfg ) ) {
            $column = $args[ 'column' ];
            if (! $column ) {
                $column = 'value';
            }
            $column = strtolower( $column );
            if ( $cfg->has_column( $column ) ) {
                return $cfg->$column;
            }
        }
        return '';
    }
?>