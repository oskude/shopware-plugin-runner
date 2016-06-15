<?php

class Shopware_Plugins_Core_FoobarLogger_Bootstrap
extends Shopware_Components_Plugin_Bootstrap
{
	public function install ()
	{
		$this->subscribeEvent(
			'sAdmin::sGetDispatchBasket::after',
			'onDispatchBasket'
		);
		$this->subscribeEvent(
			'sAdmin::sGetPremiumShippingcosts::after',
			'onShippingcosts'
		);

		return true;
	}

	private function simpleLog ($string)
	{
		# TODO: get shopware log dir
		file_put_contents("/home/vagrant/shopware/var/log/foobarlogger.log", $string, FILE_APPEND);
	}

	public function onDispatchBasket (Enlight_Event_EventArgs $args)
	{
		$this->simpleLog("sAdmin::sGetDispatchBasket\n");
	}

	public function onShippingcosts (Enlight_Event_EventArgs $args)
	{
		$this->simpleLog("sAdmin::sGetPremiumShippingcosts\n");
	}
}
