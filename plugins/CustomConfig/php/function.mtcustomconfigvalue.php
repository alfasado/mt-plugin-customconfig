<?php
function smarty_function_mtcustomconfigvalue ( $args, $ctx ) {
    $customconfig = $ctx->stash( 'config' );
    if (! isset( $customconfig ) ) {
        return $ctx->error();
    } else {
        return $customconfig->value;
    }
}
?>