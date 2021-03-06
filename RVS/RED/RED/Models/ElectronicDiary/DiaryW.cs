﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using RED.Models.DataContext;

namespace RED.Models.ElectronicDiary
{
    public class DiaryW
    {
        public DiaryW()
        {
            Products = new HashSet<Product>();
        }

        public Guid Id { get; set; }

        [Required]
        public int Number { get; set; }

        [Required(ErrorMessage = "Полето \"Дата на приемане\" е задължително!")]
        [Display(Name = "Дата на приемане")]
        public DateTime AcceptanceDateAndTime { get; set; }

        [Display(Name = "Писмо №")]
        public string LetterNumber { get; set; }

        [Required(ErrorMessage = "Датата на писмото е задължителна")]
        [Display(Name = "Писмо дата")]
        public DateTime LetterDate { get; set; }

        [Required(ErrorMessage = "Възложителя е задължителен")]
        [Display(Name = "Възложител")]
        public string Contractor { get; set; }

        [Display(Name = "Бележка")]
        public string Comment { get; set; }

        [Required]
        [Display(Name = "Клиент")]
        public Guid ClientId { get; set; }

        [Display(Name = "Клиент")]
        public virtual Client Client { get; set; }

        [Display(Name = "Заявка")]
        public virtual Request Request { get; set; }

        [Display(Name = "Продукти")]
        public virtual ICollection<Product> Products { get; set; }

        public string LetterInfo
        {
            get
            {
                if (LetterNumber != null)
                {
                    return "Писмо №" + LetterNumber + " от " + LetterDate.ToString("dd.MM.yyyy", CultureInfo.InvariantCulture);
                }
                else
                {
                    return "Писмо от " + LetterDate.ToString("dd.MM.yyyy", CultureInfo.InvariantCulture);
                }
            }
        }

        [Required(ErrorMessage = "Полето \"Час на приемане\" е задължително!")]
        [Display(Name = "Час на приемане")]
        public string AcceptanceTime
        {
            get
            {
                return AcceptanceDateAndTime.ToString("HH:mm");
            }

            set
            {
                if (!string.IsNullOrEmpty(value))
                {
                    var arguments = value.Split(':');
                    var hours = int.Parse(arguments[0]);
                    var minutes = int.Parse(arguments[1]);

                    AcceptanceDateAndTime = AcceptanceDateAndTime.AddHours(hours);
                    AcceptanceDateAndTime = AcceptanceDateAndTime.AddMinutes(minutes);
                }
            }
        }

        public string Remark
        {
            get
            {
                string remark = string.Empty;
                bool hasAcredited = false;
                bool hasNotAcredited = false;

                foreach (var product in Products)
                {
                    foreach (var ptest in product.ProductTests)
                    {
                        if (ptest.Test.AcredetationLevel.Level.Trim() == AcreditationLevels.Acredited)
                        {
                            hasAcredited = true;
                        }

                        if (ptest.Test.AcredetationLevel.Level.Trim() == AcreditationLevels.NotAcredited)
                        {
                            hasNotAcredited = true;
                        }
                    }
                }

                if (hasAcredited && hasNotAcredited)
                {
                    remark = AcreditationLevels.Acredited + "/" + AcreditationLevels.NotAcredited;
                }
                else if (hasAcredited)
                {
                    remark = AcreditationLevels.Acredited;
                }
                else if (hasNotAcredited)
                {
                    remark = AcreditationLevels.NotAcredited;
                }

                return remark;
            }
        }

        public Diary ToBase()
        {
            var diary = new Diary();
            diary.Id = Id;
            diary.Number = Number;
            diary.LetterNumber = LetterNumber;
            diary.LetterDate = LetterDate;
            diary.AcceptanceDateAndTime = AcceptanceDateAndTime;
            diary.Contractor = Contractor;
            diary.ClientId = ClientId;
            diary.Comment = Comment;

            diary.Client = Client;
            diary.Requests.Add(Request);
            diary.Products = Products;

            return diary;
        }
    }
}