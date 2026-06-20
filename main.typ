#import "thesis.typ": appendix, integration, preview, thesis

#thesis[
  #preview(kwd: [ИНСТРУМЕНТЫ РАЗРАБОТКИ, АВТОМАТИЗАЦИЯ, УПРАВЛЕНИЕ,
    ИНФРАСТРУКТУРА])[
    #include "src/preview.typ"
  ]

  #[
    #set par(leading: 0.65em)
    #outline()
  ]

  #pagebreak()

  #counter(page).update(5)
  #set page(numbering: "1")

  #include "src/intro.typ"
  #include "src/overview.typ"
  #include "src/arch.typ"
  #include "src/impl.typ"
  #include "src/conclusion.typ"

  #bibliography("references.yaml")

  <begin>
  #appendix[
    #include "src/apx.em-es.typ"
    #include "src/apx.sol.typ"
  ]
  <end>

  // #integration(who: [Роговский Ю.А.], seat: [
  //   Зав. лабораторией~#{ sym.numero }11 \
  //   ИЯФ им. Г.И. Будкера СО РАН
  // ])[
  //   Настоящий акт составлен о том, что результаты выпускной квалификационной
  //   работы студента ФГБОУ ВО "Новосибирский государственный технический
  //   университет" (НГТУ) группы ПМ-24 очной формы обучения #box[Параскуна И.Г.]
  //   на тему "Разработка прототипа платформы для управления программным
  //   обеспечением лабораторного комплекса" внедрены в рабочие процессы
  //   лаборатории~#{ sym.numero }11 Института ядерной физики имени #box[Г.И.
  //     Будкера] СО РАН. Использование результатов выпускной квалификационной
  //   работы #box[Параскуна И.Г.] позволило провести модернизацию прикладного
  //   программного комплекса без нарушения режимов работы оборудования.
  // ]
]

