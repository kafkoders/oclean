//
//  TextFieldAlertView.swift
//  InnoDoc
//
//  Created by Carlos on 27/03/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit

class TextFieldAlertView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
    }
    
    private func applyLayout() {
        //TODO PUT AN IMAGE
        containerView.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.26, alpha:1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.text = "Aviso Legal"
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .darkGray
        //descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "La información contenida en esta aplicación, con un carácter general y sin aludir a circunstancias específicas de personas o entidades concretas,  tiene un carácter meramente orientativo siendo su finalidad estrictamente didáctica. Consecuentemente  no puede ser considerada un instrumento de asesoramiento legal al carecer de la condición de opinión jurídica o profesional.\n\nLos usuarios deben tomar todas las precauciones necesarias antes de emplear la información y, en su caso, orientaciones,  asumiendo que las utilizan por su cuenta y riesgo.\n\nNi la Universidad de Salamanca ni ninguna otra persona que actúe en su nombre son responsables del uso que pueda hacerse de la información contenida en esta aplicación.\n\nLa información contenida en esta aplicación puede remitir a sitios externos sobre los que el administrador no tienen ningún control y por los cuales éste declina toda responsabilidad.\nLa información contenida refleja el estado de la cuestión en el momento de realizar la pregunta y correspondiente contestación. En este sentido deberá considerarse como una \"herramienta viva\" abierta a mejoras y su contenido puede estar sujeto a modificaciones sin previo aviso.\n\nLa presente cláusula de exención de responsabilidad no tiene por objeto limitar la responsabilidad del administrador de forma contraria a lo dispuesto por la normativa nacional que resulte de aplicación, ni excluir su responsabilidad en los casos en los que, en virtud de dichas normativa, no pueda excluirse."
    }
    
    class func instantiateFromNib() -> TextFieldAlertView {
        return Bundle.main.loadNibNamed("TextFieldAlertView", owner: nil, options: nil)!.first as! TextFieldAlertView
    }
}
