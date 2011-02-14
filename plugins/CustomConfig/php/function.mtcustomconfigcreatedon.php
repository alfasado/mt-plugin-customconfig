<?php
function smarty_function_mtcustomconfigcreatedon ( $args, $ctx ) {
    $customconfig = $ctx->stash( 'config' );
    if (! isset( $customconfig ) ) {
        return $ctx->error();
    } else {
        $args[ 'ts' ] = $customconfig->created_on;
        return $ctx->_hdlr_date( $args, $ctx );
    }
}
?>