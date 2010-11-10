
vgroup = VirtualCodeGroup.find_or_create_by_title('NSP',
                              :user => User.find_by_username('admin'))

vgroup.virtual_codes.find_or_create_by_title(
  'Care & Treatment',
  :codes =>[ Code.find_by_external_id('60204'),
             Code.find(1479)]
  )
vgroup.save!

vgroup.virtual_codes.find_or_create_by_title(
  'Prevention',
  :codes =>[
              Code.find_by_external_id('90201'),
              Code.find_by_external_id('90207'),
              Code.find_by_external_id('90208'),
              Code.find(1713)]
  )
vgroup.save!

vgroup.virtual_codes.find_or_create_by_title(
  'Impact Mitigation',
  :codes =>[
              Code.find_by_external_id('60201'),
              Code.find_by_external_id('60202'),
              Code.find_by_external_id('60203')]
  )
vgroup.save!

vgroup.virtual_codes.find_or_create_by_title(
  'Cross Cutting / Health System Strengthening',
  :codes => [
              Code.find_by_external_id('a'),
              Code.find_by_external_id('601'),
              Code.find_by_external_id('603'),
              Code.find_by_external_id('604'),
              Code.find_by_external_id('605'),
              #Code.find_by_external_id('606'),
              Code.find_by_external_id('607'),
              Code.find_by_external_id('608'),
              Code.find_by_external_id('609'),
              Code.find_by_external_id('6010'),
              Code.find_by_external_id('6011'),
              Code.find_by_external_id('6012'),
              Code.find_by_external_id('6013'),
              Code.find_by_external_id('6014'),
              Code.find_by_external_id('6015'),
              Code.find_by_external_id('6016'),
              Code.find_by_external_id('7'),
              Code.find_by_external_id('8'),
              Code.find_by_external_id('901'),
              Code.find_by_external_id('903'),
              Code.find_by_external_id('904'),
              Code.find_by_external_id('90501'),
              Code.find_by_external_id('90503'),
              Code.find_by_external_id('90504'),
              Code.find_by_external_id('90505'),
              Code.find_by_external_id('906'),
              Code.find_by_external_id('907'),
              Code.find_by_external_id('908'),
              Code.find_by_external_id('11')
              ]
  )
vgroup.save!