# साहिर का पिता इकबाल हारून खान शिकागो में एक सर्कस चलाते थे, लेकिन जब वेस्टर्न बैंक ऑफ शिकागो उनकी मदद करने से इनकार कर देता है, तो वह आत्महत्या कर लेते हैं। यह घटना साहिर के दिल पर गहरा असर छोड़ती है।

# 2. बदले की आग:
# साहिर बड़ा होकर एक प्रतिभाशाली जादूगर और एक बाइक सवार बनता है। वह उसी बैंक को बार-बार लूटता है, जिसने उसके पिता की मौत की वजह बनी थी।

# 3. पुलिस की एंट्री:
# भारत से दो पुलिस ऑफिसर – जय दीक्षित (अभिषेक बच्चन) और अली (उदय चोपड़ा) – को साहिर को पकड़ने के लिए शिकागो बुलाया जाता है।

# 4. बड़ा खुलासा – साहिर का जुड़वां भाई:
# फिल्म में एक बड़ा ट्विस्ट तब आता है जब पता चलता है कि साहिर का एक जुड़वां भाई है – समर। समर मानसिक रूप से थोड़ा कमजोर है लेकिन बहुत मासूम है। साहिर उसका इस्तेमाल बैंक लूटने में करता है क्योंकि दोनों हूबहू एक जैसे दिखते हैं, जिससे

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    public_ip_address_id          = data.azurerm_public_ip.kuch_bhi_ip.id
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = data.azurerm_key_vault_secret.vm-username.value
  admin_password                  = data.azurerm_key_vault_secret.vm-password.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher # Published ID from Azure Marketplace
    offer     = var.image_offer     # Product ID from Azure Marketplace
    sku       = var.image_sku       # Plan ID from Azure Marketplace
    version   = var.image_version   # Version of the image
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
  )

}

