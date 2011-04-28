<?php
function smarty_function_mtcustomconfigpriority ( $args, $ctx ) {
    $customconfig = $ctx->stash( 'config' );
    if (! isset( $customconfig ) ) {
        return $ctx->error();
    } else {
        return $customconfig->priority;
    }
}
?>