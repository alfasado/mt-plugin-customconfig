<?php
function smarty_function_mtcustomconfigkey ( $args, $ctx ) {
    $customconfig = $ctx->stash( 'config' );
    if (! isset( $customconfig ) ) {
        return $ctx->error();
    } else {
        return $customconfig->key;
    }
}
?>