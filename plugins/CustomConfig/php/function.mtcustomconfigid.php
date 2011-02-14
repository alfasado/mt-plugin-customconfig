<?php
function smarty_function_mtcustomconfigid ( $args, $ctx ) {
    $customconfig = $ctx->stash( 'config' );
    if (! isset( $customconfig ) ) {
        return $ctx->error();
    } else {
        return $customconfig->id;
    }
}
?>