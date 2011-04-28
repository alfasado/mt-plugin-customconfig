<?php
function smarty_function_mtcustomconfigmodifiedon ( $args, $ctx ) {
    $customconfig = $ctx->stash( 'config' );
    if (! isset( $customconfig ) ) {
        return $ctx->error();
    } else {
        $args[ 'ts' ] = $customconfig->modified_on;
        return $ctx->_hdlr_date( $args, $ctx );
    }
}
?>