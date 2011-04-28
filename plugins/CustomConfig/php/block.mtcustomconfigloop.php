<?php
function smarty_block_mtcustomconfigloop ( $args, $content, &$ctx, &$repeat ) {
    $localvars = array( 'config', '_config_counter', 'customconfig' );
    $app = $ctx->stash( 'bootstrapper' );
    $key = $args[ 'key' ];
    $value = $args[ 'value' ];
    $name = $args[ 'name' ];
    $id = $args[ 'id' ];
    $priority = $args[ 'priority' ];
    $limit = intval( $args[ 'lastn' ] );
    if (! isset ( $limit ) ) {
        $limit = 9999;
    }
    $offset = intval ( $args[ 'offset' ] );
    if ( isset ( $offset ) ) {
        $offset = 0;
    }
    $sort_order = $args[ 'sort_order' ];
    if ( $sort_order == 'descend' ) {
        $sort_order = 'DESC';
    } else {
        $sort_order = 'ASC';
    }
    $sort_by  = $args[ 'sort_by' ];
    if (! isset ( $sort_by ) ) {
        $sort_by = 'priority';
    }
    if (! isset( $content ) ) {
        $ctx->localize( $localvars );
        if ( $ctx->__stash[ 'customconfig' ] ) {
            $ctx->__stash[ 'customconfig' ] = null;
        }
        $counter = 0;
    } else {
        $counter = $ctx->stash( '_config_counter' );
    }
    $customconfig = $ctx->stash( 'customconfig' );
    if (! isset( $customconfig ) ) {
        require_once 'class.mt_customconfig.php';
        $where = "ORDER BY customconfig_{$sort_by} {$sort_order}";
        if ( $limit ) {
            $extra[ 'limit' ] = $limit;
        }
        if ( $offset ) {
            $extra[ 'offset' ] = $offset;
        }
        $sql = NULL;
        if ( $key ) {
            $where = "customconfig_key = '{$key}' AND $where ";
            $sql = 1;
        }
        if ( $value ) {
            $where = "customconfig_value = '{$value}' AND $where ";
            $sql = 1;
        }
        if ( $name ) {
            $where = "customconfig_name = '{$name}' AND $where ";
            $sql = 1;
        }
        if ( $id ) {
            $where = "customconfig_id = '{$id}' AND $where ";
            $sql = 1;
        }
        if ( $priority ) {
            $where = "customconfig_priority = '{$priority}' AND $where ";
            $sql = 1;
        }
        if (! $sql ) {
            $where = "customconfig_id=customconfig_id $where ";
        }
        $_customconfig = new CustomConfig;
        $customconfig = $_customconfig->Find( $where, false, false, $extra );
        if ( count( $customconfig ) == 0 ) {
            $customconfig = array();
        }
        $ctx->stash( 'customconfig', $customconfig );
    } else {
        $counter = $ctx->stash( '_config_counter' );
    }
    if ( $counter < count( $customconfig ) ) {
        $config = $customconfig[ $counter ];
        $ctx->stash( 'config', $config );
        $ctx->stash( '_config_counter', $counter + 1 );
        $count = $counter + 1;
        $ctx->__stash[ 'vars' ][ '__counter__' ] = $count;
        $ctx->__stash[ 'vars' ][ '__odd__' ]  = ( $count % 2 ) == 1;
        $ctx->__stash[ 'vars' ][ '__even__' ] = ( $count % 2 ) == 0;
        $ctx->__stash[ 'vars' ][ '__first__' ] = $count == 1;
        $ctx->__stash[ 'vars' ][ '__last__' ] = ( $count == count( $links ) );
        $repeat = true;
    } else {
        $ctx->restore( $localvars );
        $repeat = false;
    }
    return $content;
}
?>