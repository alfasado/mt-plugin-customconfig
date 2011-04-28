package CustomConfig::L10N::ja;
use strict;
use base 'CustomConfig::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    'Create and manage system scope coutom configuration.' => 'システムスコープのカスタム設定を作成・管理します。',
    'Custom Config' => 'カスタム設定',
    'Name' => '名前',
    'Priority' => '優先順位',
    'Key' => 'キー',
    'Value' => '値',
    'Create Custom Config' => 'カスタム設定の作成',
    'Manage Custom Config' => 'カスタム設定の管理',
    'Add' => '追加',
    'The Custom Config has been saved.' => 'カスタム設定を保存しました。',
    'The Custom Config has been deleted from the database.' => 'カスタム設定をデータベースから削除しました。',
    'Custom Config \'[_1]\' (ID:[_2]) created by \'[_3]\'' => '\'[_3]\'がカスタム設定\'[_1]\'(ID:[_2])を保存しました。',
    'Custom Config \'[_1]\' (ID:[_2]) edited by \'[_3]\''  => '\'[_3]\'がカスタム設定\'[_1]\'(ID:[_2])を更新しました。',
    'Custom Config \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がカスタム設定\'[_1]\'(ID:[_2])を削除しました。',
    '(Unknown)' => '不明なユーザー',
    'Delete selected Custom Config (x)' => '選択されたカスタム設定を削除 (x)',
);

1;